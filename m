From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] scsi: require CAP_SYS_ADMIN to write to procfs
	interface
Date: Sun, 5 Nov 2017 20:11:20 +1100
Message-ID: <CAOviyagXOJE3JqYwd3hUNA+qL0cRVafDgma8FTvq9To9iBaYmQ@mail.gmail.com>
References: <20171105025635.10843-1-asarai@suse.de>
	<20171105073121.GB1431@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20171105073121.GB1431-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I've booted it on a few of my laptops, and nothing seemed to break. Is
there a particular test-suite you'd recommend that I run?

On Sun, Nov 5, 2017 at 6:31 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Nov 05, 2017 at 01:56:35PM +1100, Aleksa Sarai wrote:
>> Previously, the only capability effectively required to operate on the
>> /proc/scsi interface was CAP_DAC_OVERRIDE (or for some other files,
>> having an fsuid of GLOBAL_ROOT_UID was enough). This means that
>> semi-privileged processes could interfere with core components of a
>> system (such as causing a DoS by removing the underlying SCSI device of
>> the host's / mount).
>
> Given that the previous patch didn't even compile, I worry that you have
> not tested this at all to see what breaks/changes in userspace with this
> type of user-visable api change.
>
> What did you do to test this?
>
> thanks,
>
> greg k-h



-- 
Aleksa Sarai (cyphar)
www.cyphar.com

From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [dm-devel] [RFC PATCH 00/32] separate operations
 from flags in the bio/request structs
Date: Wed, 11 Nov 2015 03:28:46 -0800
Message-ID: <20151111112846.GA358@infradead.org>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
	<563A36FC.6010001@sandisk.com> <563A3813.5010604@cs.wisc.edu>
	<20151107102309.GE12117@infradead.org>
	<5642F3F4.2060007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5642F3F4.2060007-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2015 at 01:53:24AM -0600, Mike Christie wrote:
> We no longer have the bvec merge functions so the original reason given
> in the thread/patch Bart referenced is no longer valid.
> 
> Offlist it was suggested that dropping the argument from submit_bio
> might still improve performance, but I modified xfs and dm and did some
> testing and did not see anything.
> 
> So the change is not needed, and it would only be done because people
> feel it would improve the interface.

I would defintively prefer the changed interface, and to me it also
looks like it would make your overall patch simpler.  If you disagree
feel free to keep it as-is for now and I'll do another pass later.

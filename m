From: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: scsi-misc.git status
Date: Tue, 06 Oct 2009 13:42:34 -0700
Message-ID: <1254861754.5318.116.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James.Bottomley-l3A5Bk7waGM@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

   On 09/11 I submitted 35 patches for the 2.6.32 merge window. On 09/18
I submitted another 24 patches. Some of the patches from the first set
were committed to scsi-misc and I haven't seen any activity with the
second set. Now the scsi-misc.git tree seems to have been reset to
linux-2.6.git (4 days ago). What is the status of scsi-misc.git?

   I know there were some reservations about the SCSI queue depth
patches that Vasu wrote and so maybe those shouldn't have been applied.
However, one of the initial 35 patches wasn't committed to linux-scsi at
the time the others were. It was a libfc formatting cleanup patch. Was
there something wrong with this patch or did it not merge cleanly with
the queue depth patches removed? I didn't see any comments.

   What about the second set?

   Missing some of the patches in the second set is particularly a
problem because some changes to netdev were made to change fcoe offload
initialization in netdev based Ethernet drivers that support it. The
corresponding fcoe stack change was in the second set submitted to
linux-scsi. Since these patches weren't pushed to linux-2.6 fcoe offload
support in 2.6.32 is broken. Should these patches be resubmitted to
scsi-rc-fixes? 

   I ensure that all patches have been reviewed, tested and should merge
with scsi-misc.git when I submit them. If you need patches re-worked
because dependent patches are rejected please let me know and I can
resubmit.

Thanks, //Rob

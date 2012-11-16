From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: UAPI disintegration for SCSI, FCoE and RDMA
Date: Fri, 16 Nov 2012 13:23:30 +0000
Message-ID: <18968.1353072210@warthog.procyon.org.uk>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dillowda-1Heg1YXhbW8@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Hi James, Robert, David,

I have patches still outstanding for the UAPI header disintegration of
linux/scsi/, linux/scsi/fs/ and linux/rdma.  I have updated them from the
original pull requests and they can be found at tags:

	disintegrate-scsi-20121116
	disintegrate-fc-20121116
	disintegrate-rdma-20121116

in:

	git://git.infradead.org/users/dhowells/linux-headers.git
	http://git.infradead.org/users/dhowells/linux-headers.git

Do you accept git pull requests or only patches through the mailing lists?
Should all three go via the SCSI tree?  Note that the MAINTAINERS' record for
RDMA points to a defunct git tree.

Thanks,
David
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

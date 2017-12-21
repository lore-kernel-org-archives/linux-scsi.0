From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] scsi: libiscsi: Allow sd_shutdown on bad transport
Date: Wed, 20 Dec 2017 21:39:40 -0500
Message-ID: <yq1zi6cg5xv.fsf@oracle.com>
References: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDVIJONZ3YDRB4555TIQKGQEFIIAFBA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1512683953-5959-1-git-send-email-rafael.tinoco-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
	(Rafael David Tinoco's message of "Thu, 7 Dec 2017 19:59:13 -0200")
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rafael David Tinoco <rafael.tinoco-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jay Vosburgh <jay.vosburgh-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Daniel Axtens <daniel.axtens-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dragan Stancevic <dragan.stancevic-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> If, for any reason, userland shuts down iscsi transport interfaces
> before proper logouts - like when logging in to LUNs manually, without
> logging out on server shutdown, or when automated scripts can't
> umount/logout from logged LUNs - kernel will hang forever on its
> sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd to all
> still existent paths.

Chris and Lee: Please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

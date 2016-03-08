From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Tue, 8 Mar 2016 09:21:08 -0800
Message-ID: <20160308172108.zkw32e5uzoau7oth@straylight.hirudinean.org>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBB4U7S3AKGQEOYO6V3Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455298733-18651-1-git-send-email-lduncan-IBi9RG/b67k@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 12, 2016 at 09:38:53AM -0800, Lee Duncan wrote:
> The scsi_transport_iscsi module already uses the ida_simple
> routines for managing the target ID, if requested to do
> so. This change replaces an ever-increasing atomic integer
> that tracks the session ID itself with the ida_simple
> family of routines. This means that the session ID
> will be reclaimed and can be reused when the session
> is freed.
> 
> Note that no maximum is placed on this value, though
> user-space currently only seems to use the lower 24-bits.
> It seems better to handle this in user space, though,
> than to limit the value range for the session ID here.
> 
> Signed-off-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>

Acked-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

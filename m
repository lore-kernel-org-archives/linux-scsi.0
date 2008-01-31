From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [2.6 patch] make __iscsi_complete_pdu() static
Date: Thu, 31 Jan 2008 14:05:00 -0600
Message-ID: <47A229EC.50204@cs.wisc.edu>
References: <20080128221127.GX8767@does.not.exist>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20080128221127.GX8767-8VHLPQtsompjxMay5xEomg@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Adrian Bunk <bunk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Olaf Kirch <olaf.kirch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Adrian Bunk wrote:
> __iscsi_complete_pdu() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 

Looks good. Thanks.

Acked-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

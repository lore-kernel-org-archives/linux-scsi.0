From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 0/4] Add bnx2i driver.
Date: Tue, 26 May 2009 21:35:50 -0500
Message-ID: <4A1CA706.1020108@cs.wisc.edu>
References: <1243113110-29635-1-git-send-email-mchan@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1243113110-29635-1-git-send-email-mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Michael Chan wrote:
> 
> James, the next 4 patches are our latest to add the bnx2i
> driver.  We've fixed up all the issues that Mike brought up.
> Please consider applying them to scsi-misc-2.6.
> 

Hey James,

We forgot to cc you and the linux list on some other postings. Dave 
Miller had ackd the drivers/net parts of the patches here:
http://marc.info/?l=linux-netdev&m=124082705613349&w=2
and in the mail had said it was ok to send through the scsi tree.

There is just some tiny comment issue in one of the patches that I think 
is probably ok to fix up after the merge into scsi-misc. A code snippet 
got commented out when it should have got removed.

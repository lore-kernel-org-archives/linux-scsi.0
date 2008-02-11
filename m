From: Pete Wyckoff <pw-pxmRpbKlMIQ@public.gmane.org>
Subject: Re: [PATCH 2/3] iscsi: bidi support - libiscsi
Date: Mon, 11 Feb 2008 11:24:31 -0500
Message-ID: <20080211162431.GA27424@osc.edu>
References: <47A20E85.6040906@panasas.com> <47A22FC4.2020804@panasas.com> <20080211154309.GA27183@osc.edu> <47B0724C.2060108@panasas.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <47B0724C.2060108-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi-help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Benny Halevy <bhalevy-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Daniel.E.Messinger-ShLqkCeKS0lBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org wrote on Mon, 11 Feb 2008 18:05 +0200:
> You are most probably right I will investigate what happened. It looks
> like I went back to some old version right? or a merge fallout
> Thanks for reviewing.
> 
> Please also test latest head-of-line code if possible + iscsi patches
> + last varlen I sent.
> 
> Is there any new patches I need for 2.6.24 or head-of-line for my 
> osd-dev tree?

Testing now.  My patch set is actually shrinking (!) thanks to some
merges.  Some rebasing was required to apply your three varlen
patches and three bidi patches, but I'm sure you'll update your tree
and push those upstream soon enough.  I'll take a look at iser bidi
then update my patch list and let you know soon.

		-- Pete

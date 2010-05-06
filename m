From: "jack wang" <jack_wang@usish.com>
Subject: RE: libsas: is there a current maintainer?
Date: Thu, 6 May 2010 12:37:43 +0800
Message-ID: <7964E35BEEE14ED4B261A4EE77D5C7F1@usish.com.cn>
References: <SNT126-W15ED7713879FB6E952A2DECEF40@phx.gbl> <1273069012.5227.64.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:36176 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0EFEhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 00:37:51 -0400
In-Reply-To: <1273069012.5227.64.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>, 'Sean Thomson' <psthomso@hotmail.com>
Cc: linux-scsi@vger.kernel.org



On Wed, 2010-05-05 at 07:07 -0700, Sean Thomson wrote:
> This is mostly a curiosity question, but who is maintaining libsas?

There's no overall maintainer, it's jointly maintained by its users.

>  I'm just starting work on a new sas driver and wondering if it is
> necessary for anything to be done to make it (or if it is already) 2.1
> compliant

I don't quite understand the question.  libsas is a software library and
2.1 is a physical layer document ... there's not much overlap.

To answer what I think the question is about, libsas is only coded to
1.1 ... the expander checking has been relaxed a bit, so it shouldn't
barf on a 2.0 configuration, but I'm not aware that anyone's actually
tested it with a self configuring expander.

James

[Jack]We had test it on PMC-Sierra's SAS2 expanders, the main issue is
expander checking as you mentioned, and we can remove the the T-T limitation
in function sas_check_parent_topology. The other problem is zone support,
when we change zone setting, the libsas can not find the change. I'm not
have
much time to dig in. 
Thanks

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


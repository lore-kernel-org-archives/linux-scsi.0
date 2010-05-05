From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: libsas: is there a current maintainer?
Date: Wed, 05 May 2010 10:16:52 -0400
Message-ID: <1273069012.5227.64.camel@mulgrave.site>
References: <SNT126-W15ED7713879FB6E952A2DECEF40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255Ab0EEOQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 10:16:57 -0400
In-Reply-To: <SNT126-W15ED7713879FB6E952A2DECEF40@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Thomson <psthomso@hotmail.com>
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



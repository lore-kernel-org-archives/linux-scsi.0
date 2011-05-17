From: Andy Grover <agrover@redhat.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Tue, 17 May 2011 10:12:00 -0700
Message-ID: <4DD2AC60.6010506@redhat.com>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>	 <1304553788.10072.241.camel@haakon2.linux-iscsi.org>	 <4DCAC075.5090007@redhat.com>	 <1305160226.19744.47.camel@haakon2.linux-iscsi.org>	 <1305337311.7102.88.camel@haakon2.linux-iscsi.org>	 <4DCF1215.2010406@redhat.com> <1305617458.2856.139.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1EQRM3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 13:12:29 -0400
In-Reply-To: <1305617458.2856.139.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Fleischmann <mwf@risingtidesystems.com>

On 05/17/2011 12:30 AM, Nicholas A. Bellinger wrote:
> So to clarify here.  We intend to keep everything related to single
> target management for rtslib/configshell/rtsadmin available under AGPLv3
> on http://www.risingtidesystems.com/git/  This currently includes:
> 
> *) high level single node management, libs, and docs for target core
> *) high level single node management, libs, and docs for fabrics using 
>    the mainline target_core_fabric_config.c framework.
> *) configshell python library and docs
> *) Ability to build rpm/deb source packages with necessary dependecies
> 
> Our commerical versions will include a number of integrated features to
> complement single node target core/fabric management, along with
> allowing rtsadmin-v2 to function in a larger multi-node cluster
> environment.
> 
> To the question of contributing code to the AGPLv3 licensed community
> edition of rtslib/configshell/rtsadmin, we are doing a dual licensing
> model like MySQL.   Please feel free to contact Marc directly with
> specific questions that you may have wrt to licensing for our python
> code.

Thanks for the clarification.

Regards -- Andy

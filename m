From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 14:02:10 -0500
Message-ID: <550C6EB2.50304@cs.wisc.edu>
References: <20150320135742.63df219b@leda.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56832 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbbCTTCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 15:02:25 -0400
In-Reply-To: <20150320135742.63df219b@leda.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Hesse <list@eworm.de>, linux-scsi@vger.kernel.org

On 03/20/2015 07:57 AM, Christian Hesse wrote:
> Hello everybody!
> 
> I reported this issue at LKML [0] but received no answer. Hopefully
> linux-scsi is a better place...
> 
> Beginning with linux 3.19 I see an iSCSI regressen. This works perfectly with
> linux 3.18.x (tested with 3.18.6) and before. Effected kernels I tested are
> 3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.
> 

Could you take a wrireshark/tcpdump trace when running 3.18 and 3.19? We
can then see what bits are different and narrow down the patch/change.


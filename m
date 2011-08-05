From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC] bsg documentation for SAS SMP pass-through
Date: Fri, 05 Aug 2011 14:08:20 +0900 (JST)
Message-ID: <20110805.140820.1305564732068177438.fujita.tomonori@lab.ntt.co.jp>
References: <4E38A927.5080101@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:63051 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1HEFrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 01:47:08 -0400
In-Reply-To: <4E38A927.5080101@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On Tue, 02 Aug 2011 21:49:27 -0400
Douglas Gilbert <dgilbert@interlog.com> wrote:

> Seems as though there are multiple bsg pass-throughs but
> hardly any documentation (please correct me if I am wrong).
> For example, in the kernel source Documentation sub-tree
> "bsg" is only mentioned in one file:
>    scsi/scsi_fc_transport.txt
> and that is only a passing reference.
> 
> So I will start the ball rolling with some documentation
> of using the bsg pass-through for the SAS Serial Management
> Protocol (SMP). SMP is mainly used to access and control
> SAS expanders. See the attached file.

Can we put this under Documentation/scsi now? Hopefully, we would move
the bsg part of this into Documentation/block and improve it.

Thanks,

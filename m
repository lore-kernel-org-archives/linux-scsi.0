From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 29/32] cxlflash: Fix to double the delay each time
Date: Wed, 30 Sep 2015 10:08:21 +1000
Message-ID: <87bncku5u2.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223157-10039-1-git-send-email-mrochs@linux.vnet.ibm.com> <87wpvat33j.fsf@gamma.ozlabs.ibm.com> <11CB17AB-0383-41C8-8398-7B875E480A82@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36447 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbI3AIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 20:08:31 -0400
Received: by pablk4 with SMTP id lk4so19952071pab.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 17:08:30 -0700 (PDT)
In-Reply-To: <11CB17AB-0383-41C8-8398-7B875E480A82@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <manoj@linux.vnet.ibm.com>

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

>> On Sep 28, 2015, at 8:40 PM, Daniel Axtens <dja@axtens.net> wrote:
>> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA512
>> 
>> "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:
>> 
>>> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>>> 
>>> The operator used to double the delay is incorrect and
>>> does not result in delay doubling.
>>> 
>>> To fix, use a left shift instead of the XOR operator.
>>> 
>> I can see that the patch is correct, but this commit message is a bit
>> confusing. What delay? In what circumstances are you doubling it? Why?
>
> This is the response delay while resetting the master context. The reset
> is performed by writing a bit and then waiting for it to clear. While waiting
> for it to clear, the code relaxes the delta between MMIO reads.

OK. If you do a v5, please include this in the commit message.

Regards,
Daniel

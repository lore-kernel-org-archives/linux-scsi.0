From: Richard Yao <ryao@gentoo.org>
Subject: Re: scsi: lpfc_scsi: Remove unused variables
Date: Thu, 07 Jun 2012 02:21:08 -0400
Message-ID: <4FD04854.5010304@gentoo.org>
References: <4FD0434B.7090405@gentoo.org> <20120607061255.GB3210@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56310 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759873Ab2FGGWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jun 2012 02:22:15 -0400
In-Reply-To: <20120607061255.GB3210@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

On 06/07/12 02:12, Jonathan Nieder wrote:
> Hi Richard,
>
> Richard Yao wrote:
>
>> This is my first time patch submission. The commit message should
>> explain the issue.
>>
>> commit ba8c7a7a629b736fdc1abceaa3ec49f8820aec08
>> Author: Richard Yao <ryao@cs.stonybrook.edu>
>> Date:   Thu Jun 7 01:44:31 2012 -0400
>>
>>     scsi: lpfc_scsi: Remove unused variables
>>
>>     Kernels built with CONFIG_SCSI_LPFC fail to compile due to the use of
>>     -Werror=unused-variable. We solve that by removing some unused
>>     variables.
> Wouldn't a saner fix be to stop using -Werror=unused-variable, or am I
> missing something subtle?
>
> (Since v3.4-rc1~6^2~48 the makefile seems to use plain -Werror, which
> seems even worse, since it means any random compiler bug that triggers
> a new warning will break the build.)
>
> Thanks and hope that helps,
> Jonathan

Using -Werror enables us to catch potential runtime issues before they
happen. This one is not a runtime issue, but the compiler is right in
stating that these variables serve no purpose. My opinion is that
occasional noise due to -Werror won't be a problem. Also, decisions on
-Werror probably should be made by either the subsystem maintainer or
the branch maintainer.

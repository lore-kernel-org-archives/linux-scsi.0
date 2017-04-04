From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION] v4.11-rc3: lpfc: panic during module removal /
 shutdown
Date: Tue, 4 Apr 2017 02:10:47 +0000
Message-ID: <95631fe6-9f0a-fa88-2900-6fc54c4115bb@ce.jp.nec.com>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
 <9110d410-8522-9806-8444-44276de9af51@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tyo161.gate.nec.co.jp ([114.179.232.161]:55656 "EHLO
        tyo161.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdDDCLe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 22:11:34 -0400
In-Reply-To: <9110d410-8522-9806-8444-44276de9af51@linux.vnet.ibm.com>
Content-Language: ja-JP
Content-ID: <62C9D988BA78734B8F616D5699B9C6DD@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
Cc: "anton@samba.org" <anton@samba.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 04/04/17 06:53, Mauricio Faria de Oliveira wrote:
> Hi Junichi,
> 
> On 03/28/2017 11:29 PM, Junichi Nomura wrote:
>> Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications"),
>> "rmmod lpfc" starting to cause panic or corruption due to double free.
> 
> Thanks for the report. Can you please check whether the patch just sent
> ([PATCH] lpfc: fix double free of bound CQ/WQ ring pointer) resolves it?

It works for me. Thank you!

Considering future maintenance, it might be a bit fragile to just depend
on the code comment about representing the relation between cq/wq and
shared pring but it's maintainers' choice.

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.

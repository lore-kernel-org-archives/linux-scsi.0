From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/3] be2iscsi: Adding a shutdown Routine
Date: Wed, 24 Aug 2011 10:53:42 +0200
Message-ID: <3b1ab408eae794e1ae3a8f9331cd5249.squirrel@webmail.sf-mail.de>
References: <1314032910-2304-1-git-send-email-jayamohan.kallickal@emulex.com>
    <1aea287b-60e9-4ae7-95f8-fdbdc272d622@exht1.ad.emulex.com>
    <4E541995.5070408@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:60034 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab1HXIxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:53:44 -0400
In-Reply-To: <4E541995.5070408@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, james.bottomley@parallels.com, linux-scsi@vger.kernel.org

> On 08/22/2011 12:08 PM, Jayamohan Kallickal wrote:
>> +static void beiscsi_remove(struct pci_dev *pcidev)
>> +{
>> +
>> +	struct beiscsi_hba *phba = NULL;
>> +
>> +	phba = pci_get_drvdata(pcidev);
>
>
>> +static void beiscsi_shutdown(struct pci_dev *pcidev)
>> +{
>> +
>> +	struct beiscsi_hba *phba = NULL;
>> +
>> +	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
>
>
> No need for casting.

And no need to initialize to NULL either. Best would be

struct beiscsi_hba *phba = pci_get_drvdata(pcidev);

in both cases.

Eike

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Wed, 27 Sep 2017 21:42:59 -0400
Message-ID: <yq13777a998.fsf@oracle.com>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
        <423FD6710FB8FB4F8728F93591889F9A5B8CD1FA@avsrvexchmbx2.microsemi.net>
        <b15b69e2-0d41-56cd-2952-a214d7ad7973@linux.vnet.ibm.com>
        <yq1fubafooe.fsf@oracle.com>
        <423FD6710FB8FB4F8728F93591889F9A5B8D13DE@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A5B8D13DE@avsrvexchmbx2.microsemi.net>
        (Dave Carroll's message of "Wed, 27 Sep 2017 19:26:02 +0000")
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "dougmill@linux.vnet.ibm.com" <dougmill@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org


Dave,

>> 
> Previously we had used sleep to delay until the controller got its
> mind back, but early testing indicated it wasn't needed. I'm good with
> this.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

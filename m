From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v8] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 29 Jun 2016 16:54:53 +0200
Message-ID: <bc9d5ba0-4220-18ac-aab0-0e7572c8c26d@sandisk.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
 <2aa7660d-2c9a-08bf-59f6-7282a0a7a6f4@sandisk.com>
 <008A3B47-6BAE-42FA-8D65-66D0F0C7747B@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <008A3B47-6BAE-42FA-8D65-66D0F0C7747B@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "joe@perches.com" <joe@perches.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tyreld@linux.vnet.ibm.com" <tyreld@linux.vnet.ibm.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 06/29/2016 04:43 PM, Bryant G. Ly wrote:
> It looks like the masking fixes the device mapper=E2=80=99s ability t=
o find the disk=E2=80=A6.

Is the multipath client available in your initrd? If so, running=20
multipath -ll -v<n> with n >=3D 3 should reveal why multipathd ignored=20
certain disks.

Bart.

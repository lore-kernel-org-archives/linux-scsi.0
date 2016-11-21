From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: Re: [PATCH] scsi: hisi_sas: Add a missing call to kfree
Date: Mon, 21 Nov 2016 14:20:05 +0100
Message-ID: <0edd4edf-f7c8-053d-7eba-724757dc7d43@gmail.com>
References: <20161119174259.20344-1-lambert.quentin@gmail.com>
 <e1e060ba-a231-b4f3-4a41-f9fac9ca2d54@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e1e060ba-a231-b4f3-4a41-f9fac9ca2d54@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/21/2016 01:53 PM, John Garry wrote:
> However I have noticed that we should do a call to hisi_sas_free() for 
> this failure, and later failures in the probe.
I don't understand why, and would welcome the opportunity to learn 
something.

Quentin

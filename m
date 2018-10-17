From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi: aic94xx: mark expected switch fall-throughs
Date: Wed, 17 Oct 2018 07:03:03 +0200
Message-ID: <5cd48c48-8f52-117a-07e2-d2b530af7698@embeddedor.com>
References: <20181004071009.GA13875@embeddedor.com>
 <yq11s8ppcap.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11s8ppcap.fsf@oracle.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 10/17/18 3:55 AM, Martin K. Petersen wrote:

>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
> 
> Applied to 4.20/scsi-queue.
> 

Thank you, Martin.
--
Gustavo

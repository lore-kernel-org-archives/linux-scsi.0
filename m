From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] enable FUA support in libata
Date: Fri, 13 Apr 2012 10:18:32 -0400
Message-ID: <4F8835B8.2060400@garzik.org>
References: <20120413081104.GA4953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120413081104.GA4953@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/13/2012 04:11 AM, Zheng Liu wrote:
> Hi Jeff and list,
>
> Recently I met a problem about FUA support of SATA disk.  In my machine,
> it has a SATA disk that supports FUA feature.  But after system starts
> up, it displays that the disk cannot support FUA from dmesg.
>
> I notice this commit (c3c013a2).  It disables FUA support in all of SATA
> disk.  But the commit log is too simple to know why we should disable
> FUA support in libata.  Could you please explain it?  Thank you.

FUA support in the block layer wanted speed and guarantees that early 
FUA drives were simply not providing.




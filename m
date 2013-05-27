From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: Re: [PATCH 04/24] drivers/scsi/initio: Convert to module_pci_driver
Date: Mon, 27 May 2013 15:41:43 +0800
Message-ID: <51A30E37.9020701@huawei.com>
References: <1369621717-5860-1-git-send-email-libo.chen@huawei.com> <1369636713.1904.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369636713.1904.8.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Libo Chen <libo.chen@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

On 2013/5/27 14:38, James Bottomley wrote:
> On Mon, 2013-05-27 at 10:28 +0800, Libo Chen wrote:
>> use module_pci_driver instead of init/exit, make code clean.
> 
> For the ancient drivers, like this, the principal is that we really
> don't touch except for tested bug fixes.  For the current ones (like
> mvumi) it's up to the maintainer.
> 
> James
Hi james,

Thank you for your explanation!


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

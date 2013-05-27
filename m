From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/24] drivers/scsi/initio: Convert to module_pci_driver
Date: Sun, 26 May 2013 23:38:33 -0700
Message-ID: <1369636713.1904.8.camel@dabdike>
References: <1369621717-5860-1-git-send-email-libo.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369621717-5860-1-git-send-email-libo.chen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Libo Chen <libo.chen@huawei.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-05-27 at 10:28 +0800, Libo Chen wrote:
> use module_pci_driver instead of init/exit, make code clean.

For the ancient drivers, like this, the principal is that we really
don't touch except for tested bug fixes.  For the current ones (like
mvumi) it's up to the maintainer.

James

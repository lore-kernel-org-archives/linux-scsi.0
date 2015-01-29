From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi, be2iscsi, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
Date: Thu, 29 Jan 2015 12:03:38 +0100
Message-ID: <1959928.K6oPOZ8N2K@wuerfel>
References: <1422495422-25281-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422495422-25281-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Behan Webster <behanw@converseincode.com>
Cc: JBottomley@parallels.com, jayamohan.kallickal@emulex.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 28 January 2015 17:37:02 Behan Webster wrote:
> Missing MODULE_DEVICE_TABLE for pci ids from be2iscsi driver found by clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---

Like one previous patch, the change is good, the description is wrong.
This patch removes a duplicate MODULE_DEVICE_TABLE entry.

	Arnd

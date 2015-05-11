From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 1/1] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Mon, 11 May 2015 07:28:00 -0400
Message-ID: <20150511112800.GA11388@htj.duckdns.org>
References: <1431333375-30433-1-git-send-email-stripathi@apm.com>
 <1431333375-30433-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431333375-30433-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Hello, Suman.

On Mon, May 11, 2015 at 02:06:15PM +0530, Suman Tripathi wrote:
> -#ifdef CONFIG_ACPI
> -static const struct acpi_device_id xgene_ahci_acpi_match[] = {
> -	{ "APMC0D0D", },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
> -#endif
> -
> -static const struct of_device_id xgene_ahci_of_match[] = {
> -	{.compatible = "apm,xgene-ahci"},
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);

I applied the patch as-is this time but please don't combine code
movement with actual changes in the future.  Split them out to
separate patches.  It makes the changes a lot easier to follow and
verify.

Thanks.

-- 
tejun

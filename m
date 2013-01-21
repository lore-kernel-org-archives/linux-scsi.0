From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v13 8/9] libata: do not suspend port if normal ODD is
 attached
Date: Mon, 21 Jan 2013 15:42:55 -0500
Message-ID: <50FDA84F.8030204@pobox.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com> <1358241665-2156-9-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1358241665-2156-9-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/15/2013 04:21 AM, Aaron Lu wrote:
> For ODDs, the upper layer will poll for media change every few
> seconds, which will make it enter and leave suspend state very
> often. And as each suspend will also cause a hard/soft reset,
> the gain of runtime suspend is very little while the ODD may
> malfunction after constantly being reset. So the idle callback
> here will not proceed to suspend if a non-ZPODD capable ODD is
> attached to the port.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>   drivers/ata/libata-core.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)

applied patches #2-6 and #8



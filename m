From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v6 4/7] libata: acpi: set can_power_off for both ODD and
 HD
Date: Thu, 06 Sep 2012 22:37:40 -0400
Message-ID: <50495DF4.1070302@pobox.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <1346768680-7287-5-git-send-email-aaron.lwe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1346768680-7287-5-git-send-email-aaron.lwe@gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 09/04/2012 10:24 AM, Aaron Lu wrote:
> From: Aaron Lu <aaron.lu@intel.com>
>
> Hard disk may also be runtime powered off, so set can_power_off flag
> for it too if condition satisfies.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>




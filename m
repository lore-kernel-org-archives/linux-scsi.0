From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v2 7/8] PM / Runtime: Add can_power_off flag to subsys data
Date: Mon, 19 Mar 2012 09:34:08 +0800
Message-ID: <CAF1ivSbJi6rOYJ0wm7mPj2GtRG=UDHkm5TrbCHcSpup6H5EQjQ@mail.gmail.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	<1330592577-16546-8-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1330592577-16546-8-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 1, 2012 at 5:02 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Parent device will check child's can_power_off flag to see if child d=
evice can
> be powered off.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> =A0include/linux/pm.h | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index e4982ac..2e74531 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -465,6 +465,7 @@ struct pm_subsys_data {
> =A0#ifdef CONFIG_PM_GENERIC_DOMAINS
> =A0 =A0 =A0 =A0struct pm_domain_data *domain_data;
> =A0#endif
> + =A0 =A0 =A0 bool can_power_off;

Hi Rafael,

I moved can_power_off flag to pm_subsys_daa.
SCSI/SATA will use it.

Is it OK to you?

Thanks,
Lin Ming

> =A0};
>
> =A0struct dev_pm_info {
> --
> 1.7.2.5

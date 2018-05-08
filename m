From: Andres Rodriguez <andresx7@gmail.com>
Subject: Re: [PATCH v6 13/13] Documentation: clarify firmware_class provenance
 and why we can't rename the module
Date: Tue, 8 May 2018 14:53:39 -0400
Message-ID: <10c2aa7d-eaa5-80f9-f831-7e31762ff149@gmail.com>
References: <20180508181247.19431-1-mcgrof@kernel.org>
 <20180508181247.19431-14-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-14-mcgrof@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, gregkh@linuxfoundation.org
Cc: andresx7@gmail.com, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@da
List-Id: linux-scsi@vger.kernel.org



On 2018-05-08 02:12 PM, Luis R. Rodriguez wrote:
> Clarify the provenance of the firmware loader firmware_class module name
> and why we cannot rename the module in the future.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>   .../driver-api/firmware/fallback-mechanisms.rst          | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> index a39323ef7d29..a8047be4a96e 100644
> --- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
> +++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> @@ -72,9 +72,12 @@ the firmware requested, and establishes it in the device hierarchy by
>   associating the device used to make the request as the device's parent.
>   The sysfs directory's file attributes are defined and controlled through
>   the new device's class (firmware_class) and group (fw_dev_attr_groups).
> -This is actually where the original firmware_class.c file name comes from,
> -as originally the only firmware loading mechanism available was the
> -mechanism we now use as a fallback mechanism.
> +This is actually where the original firmware_class module name came from,
> +given that originally the only firmware loading mechanism available was the
> +mechanism we now use as a fallback mechanism, which which registers a

Just a tiny repeated word here, "which which".

-Andres


> +struct class firmware_class. Because the attributes exposed are part of the
> +module name, the module name firmware_class cannot be renamed in the future, to
> +ensure backward compatibilty with old userspace.
>   
>   To load firmware using the sysfs interface we expose a loading indicator,
>   and a file upload firmware into:
> 

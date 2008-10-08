From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 03/12] adt7473: Fix some bogosity in
 documentation file.
Date: Wed, 8 Oct 2008 11:08:17 +0200
Message-ID: <20081008110817.163bee97@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011839.12701.16915.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:45074 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHJJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 05:09:03 -0400
In-Reply-To: <20081007011839.12701.16915.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:18:39 -0700, Darrick J. Wong wrote:
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/adt7473 |   30 +++++++++++-------------------
>  1 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/hwmon/adt7473 b/Documentation/hwmon/adt7473
> index 2126de3..8bffc41 100644
> --- a/Documentation/hwmon/adt7473
> +++ b/Documentation/hwmon/adt7473
> @@ -14,18 +14,18 @@ Description
>  
>  This driver implements support for the Analog Devices ADT7473 chip family.
>  
> -The LM85 uses the 2-wire interface compatible with the SMBUS 2.0
> +The ADT7473 uses the 2-wire interface compatible with the SMBUS 2.0
>  specification. Using an analog to digital converter it measures three (3)
> -temperatures and two (2) voltages. It has three (3) 16-bit counters for
> -measuring fan speed. There are three (3) PWM outputs that can be used
> -to control fan speed.
> +temperatures and two (2) voltages. It has four (4) 16-bit counters for
> +measuring fan speed. There are three (3) PWM outputs that can be used to
> +control fan speed.
>  
> -A sophisticated control system for the PWM outputs is designed into the
> -LM85 that allows fan speed to be adjusted automatically based on any of the
> -three temperature sensors. Each PWM output is individually adjustable and
> +A sophisticated control system for the PWM outputs is designed into the ADT7473
> +that allows fan speed to be adjusted automatically based on any of the three
> +temperature sensors. Each PWM output is individually adjustable and
>  programmable. Once configured, the ADT7473 will adjust the PWM outputs in
> -response to the measured temperatures without further host intervention.
> -This feature can also be disabled for manual control of the PWM's.
> +response to the measured temperatures without further host intervention.  This
> +feature can also be disabled for manual control of the PWM's.

The (unneeded) reformatting of the paragraphs makes the changes look
much bigger than they really are. This doesn't help reviewing. I've
reverted these changes.

>  
>  Each of the measured inputs (voltage, temperature, fan speed) has
>  corresponding high/low limit values. The ADT7473 will signal an ALARM if
> @@ -46,14 +46,6 @@ from the raw value to get the temperature value.
>  The Analog Devices datasheet is very detailed and describes a procedure for
>  determining an optimal configuration for the automatic PWM control.
>  
> -Hardware Configurations
> ------------------------
> -
> -The ADT7473 chips have an optional SMBALERT output that can be used to
> -signal the chipset in case a limit is exceeded or the temperature sensors
> -fail. Individual sensor interrupts can be masked so they won't trigger
> -SMBALERT. The SMBALERT output if configured replaces the PWM2 function.
> -
>  Configuration Notes
>  -------------------
>  
> @@ -61,8 +53,8 @@ Besides standard interfaces driver adds the following:
>  
>  * PWM Control
>  
> -* pwm#_auto_point1_pwm and pwm#_auto_point1_temp and
> -* pwm#_auto_point2_pwm and pwm#_auto_point2_temp -
> +* pwm#_auto_point1_pwm and temp#_auto_point1_temp and
> +* pwm#_auto_point2_pwm and temp#_auto_point2_temp -
>  
>  point1: Set the pwm speed at a lower temperature bound.
>  point2: Set the pwm speed at a higher temperature bound.

Patch applied, thanks.

-- 
Jean Delvare

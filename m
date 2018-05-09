From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v6 12/13] Documentation: remove stale firmware API
 reference
Date: Wed, 9 May 2018 12:12:09 -0300
Message-ID: <20180509121209.1e332f63@vento.lan>
References: <20180508181247.19431-1-mcgrof@kernel.org>
        <20180508181247.19431-13-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-13-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc
List-Id: linux-scsi@vger.kernel.org

Em Tue,  8 May 2018 11:12:46 -0700
"Luis R. Rodriguez" <mcgrof@kernel.org> escreveu:

> It refers to a pending patch, but this was merged eons ago.

Didn't know that such patch was already merged. Great!

Regards,
Mauro

> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  Documentation/dell_rbu.txt | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.txt
> index 0fdb6aa2704c..077fdc29a0d0 100644
> --- a/Documentation/dell_rbu.txt
> +++ b/Documentation/dell_rbu.txt
> @@ -121,9 +121,6 @@ read back the image downloaded.
>  
>  .. note::
>  
> -   This driver requires a patch for firmware_class.c which has the modified
> -   request_firmware_nowait function.
> -

>     Also after updating the BIOS image a user mode application needs to execute
>     code which sends the BIOS update request to the BIOS. So on the next reboot
>     the BIOS knows about the new image downloaded and it updates itself.

You should likely remove the "Also" here.

With that,

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Regards,
Mauro

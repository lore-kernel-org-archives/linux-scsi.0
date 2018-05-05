From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
Date: Sat, 05 May 2018 22:26:46 +0200
Message-ID: <m3a7td6e7t.fsf@pm.waw.pl>
References: <20180504174356.13227-1-mcgrof@kernel.org>
        <m3lgczcjt7.fsf@pm.waw.pl> <20180504195835.GU27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504195835.GU27853@wotan.suse.de> (Luis R. Rodriguez's
        message of "Fri, 4 May 2018 19:58:35 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, davem@davemloft.net, maco@android.com, arve@android.com, tkjos@andro
List-Id: linux-scsi@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> So we can nuke CONFIG_WANXL_BUILD_FIRMWARE now?

I'm uncertain I understand why do you want it, or maybe what are you
trying to do at all.

And what use would wanxlfw.S (the assembly source) have if the option is
removed?

>> It's more about delivering the .S source for the firmware, I guess.
>> Nobody is expected to build it. The fw is about 2.5 KB and is directly
>> linked with the driver.
>
> :P Future work I guess would be to just use the firmware API and stuff
> it into linux-firmware?

Who's going to make it happen?
The last time I checked (several years ago), wanXL worked. Who's going
to test it after the change?

I assume linux-firmware could include fw source and there would be means
to build the binary.

Just to be sure: the wanXL firmware has exactly nothing to do with FW
loader, nothing depends on it (nor the other way around), it's just
(with the rest of the wanXL code) an old piece of a driver for an old
card.

The question is, what do we gain by messing with it?
-- 
Krzysztof Halasa

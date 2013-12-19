From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: randconfig build error with next-20131218, in
 drivers/target/target_core_alua.c
Date: Wed, 18 Dec 2013 16:00:48 -0800
Message-ID: <1387411248.5567.4.camel@haakon3.risingtidesystems.com>
References: <CA+r1ZhieKb_Y-e51vud0Ot5xm2O+hkp7nX6tNPpcZ02zVRq+9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+r1ZhieKb_Y-e51vud0Ot5xm2O+hkp7nX6tNPpcZ02zVRq+9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jim,

On Wed, 2013-12-18 at 06:45 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `core_alua_state_lba_dependent':
> /home/jim/linux/drivers/target/target_core_alua.c:492: undefined
> reference to `__umoddi3'
> make: *** [vmlinux] Error 1

Thanks for the heads up.  A patch for this has been merged into the
original, and will be appearing in today's (12192013) linux-next tree.

Thank you,

--nab

From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Wed, 10 Sep 2008 02:05:57 +0200
Message-ID: <20080910000557.GA4478@orion.carnet.hr>
References: <20080909.143012.193704777.davem@davemloft.net> <20080909220038.GA13300@orion.carnet.hr> <20080909.155716.106283970.davem@davemloft.net> <20080909.155951.129856467.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080909.155951.129856467.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2008 at 03:59:51PM -0700, David Miller wrote:
> > > Exactly. And this *has* worked, up to now. I would run update-initramfs and
> > > it would assemble the initial ramdisk and all was well.
> > 
> > I wonder if the new firmware code looks for firmware under a different
> > directory in the initramfs or filesystem, such as /lib/firmware/${KERNEL_VERSION}/
> > and this is what is burning you.
> > 
> > Wish I could be more help, this stuff is just as perplexing to me :-/
> 
> I wonder if you have to do some "make firmware_install" or similar now.

Hm, I tried that, and got a bunch of new files put in /lib/firmware, but
still none of it seems to be qla2xxx-related, so it doesn't like something
worth a test (reboot). And it's also not restricted to a version directory,
so I guess that's not it, either.

JFTR, here's the list:

/lib/firmware/dsp56k
/lib/firmware/dsp56k/bootstrap.bin
/lib/firmware/korg
/lib/firmware/korg/k1212.dsp
/lib/firmware/atmsar11.fw
/lib/firmware/ess
/lib/firmware/ess/maestro3_assp_kernel.fw
/lib/firmware/ess/maestro3_assp_minisrc.fw
/lib/firmware/intelliport2.bin
/lib/firmware/ttusb-budget
/lib/firmware/ttusb-budget/dspbootcode.bin
/lib/firmware/tr_smctr.bin
/lib/firmware/sb16
/lib/firmware/sb16/mulaw_main.csp
/lib/firmware/sb16/alaw_main.csp
/lib/firmware/sb16/ima_adpcm_init.csp
/lib/firmware/sb16/ima_adpcm_playback.csp
/lib/firmware/sb16/ima_adpcm_capture.csp
/lib/firmware/yamaha
/lib/firmware/yamaha/ds1_ctrl.fw
/lib/firmware/yamaha/ds1_dsp.fw
/lib/firmware/yamaha/ds1e_ctrl.fw
/lib/firmware/dabusb
/lib/firmware/dabusb/firmware.fw
/lib/firmware/dabusb/bitstream.bin
/lib/firmware/emi26
/lib/firmware/emi26/loader.fw
/lib/firmware/emi26/firmware.fw
/lib/firmware/emi26/bitstream.fw
/lib/firmware/emi62
/lib/firmware/emi62/loader.fw
/lib/firmware/emi62/bitstream.fw
/lib/firmware/emi62/spdif.fw
/lib/firmware/emi62/midi.fw
/lib/firmware/kaweth
/lib/firmware/kaweth/new_code.bin
/lib/firmware/kaweth/trigger_code.bin
/lib/firmware/kaweth/new_code_fix.bin
/lib/firmware/kaweth/trigger_code_fix.bin
/lib/firmware/keyspan
/lib/firmware/keyspan/mpr.fw
/lib/firmware/keyspan/usa18x.fw
/lib/firmware/keyspan/usa19.fw
/lib/firmware/keyspan/usa19qi.fw
/lib/firmware/keyspan/usa19qw.fw
/lib/firmware/keyspan/usa19w.fw
/lib/firmware/keyspan/usa28.fw
/lib/firmware/keyspan/usa28xa.fw
/lib/firmware/keyspan/usa28xb.fw
/lib/firmware/keyspan/usa28x.fw
/lib/firmware/keyspan/usa49w.fw
/lib/firmware/keyspan/usa49wlc.fw
/lib/firmware/ti_3410.fw
/lib/firmware/ti_5052.fw
/lib/firmware/edgeport
/lib/firmware/edgeport/boot.fw
/lib/firmware/edgeport/boot2.fw
/lib/firmware/edgeport/down.fw
/lib/firmware/edgeport/down2.fw
/lib/firmware/edgeport/down3.bin
/lib/firmware/whiteheat_loader.fw
/lib/firmware/whiteheat.fw
/lib/firmware/keyspan_pda
/lib/firmware/keyspan_pda/keyspan_pda.fw
/lib/firmware/keyspan_pda/xircom_pgs.fw
/lib/firmware/vicam
/lib/firmware/vicam/firmware.fw
/lib/firmware/cpia2
/lib/firmware/cpia2/stv0672_vp4.bin

-- 
     2. That which causes joy or happiness.

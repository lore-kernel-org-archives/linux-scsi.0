From: Tejun Heo <tj@kernel.org>
Subject: Re: Use-after-free in ata_qc_issue
Date: Sun, 22 Sep 2013 17:47:33 -0400
Message-ID: <20130922214733.GB27616@mtj.dyndns.org>
References: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
 <20130922163913.GE28571@htj.dyndns.org>
 <CACT4Y+aGOzEdGZ_rnJ_52hWCph-nyDhd1ukKW=8M0QNSyR0WpA@mail.gmail.com>
 <CACT4Y+bKPWkiLJEC2tk076TmPcYcXb_BuKiSG9H2BoWnOZJuiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bKPWkiLJEC2tk076TmPcYcXb_BuKiSG9H2BoWnOZJuiQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-ide@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>, Marc C <marc.ceeeee@gmail.com>, aaron.lu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sun, Sep 22, 2013 at 11:59:53AM -0700, Dmitry Vyukov wrote:
> I've noticed that free happens in scsi_error_handler thread, so maybe
> a timeout or some other error condition is involved here.
> It is possible that timeout happens while the request is still being
> in process of submitting (in ata_scsi_queuecmd)?

Yeah, could be.  IIRC, there's still race condition in block / scsi
timeout handling.  Hmmm...

-- 
tejun

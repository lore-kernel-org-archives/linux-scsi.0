From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 09:15:31 -0700
Message-ID: <1185898532.2766.2.camel@laptopd505.fenrus.org>
References: <20070705194909.337398431@intel.com>
	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>
	 <1185891382.2750.8.camel@laptopd505.fenrus.org>
	 <46AF4B05.4010700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46AF4B05.4010700@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org


> They were hardware problems.  I don't think any amount of proper
> implementation can fix them.  I have one DVD RAM somewhere in my pile of
> hardware which locks up solidly if any link PS mode is used and had a

and the AHCI ALPM code decides to use power savings on this device? if
so, please give us the idents so that we can add it to the blacklist as
the first entry... (or can buy it to check it in detail first)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org


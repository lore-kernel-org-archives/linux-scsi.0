From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 23:58:26 +0900
Message-ID: <46AF4E12.8060204@gmail.com>
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com> <1185891382.2750.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1185891382.2750.8.camel@laptopd505.fenrus.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> either sucks. AHCI ALPM ought to work if it's supported; it's what other
> operating systems also use... 

A question.  Does the other OS enable ALPM without checking against
white/black list?  Or is it enabled only on certain configurations -
e.g. specific notebooks, etc?

-- 
tejun

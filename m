From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: esp_scsi QTAG in FAS216
Date: Sun, 30 Oct 2016 13:33:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610301331301.20114@nippy.intranet>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com> <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com> <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net>
 <alpine.LNX.2.00.1610281658120.30954@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1610281658120.30954@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: schmitzmic@gmail.com, jongk@linux-m68k.org, tuomas.vainikka@aalto.fi, geert@linux-m68k.org, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 29 Oct 2016, I wrote:

> 
> On Sun, 13 Apr 2014, David Miller wrote:
> 
> > 
> > But oddly in the NCR53CX docs:
> > 
> > 	http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/NCR53C9X.txt
> > 
> > it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer 
> > grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB, 
> > which enables both features.
> 
> Yes, so setting the ESP_CONFIG2_SCSI2ENAB bit is correct. The only 
> problem is, doesn't the ESP_CONFIG3_TMS bit get cleared again later, 
> when the CONFIG3 register is written to?
> 

Nevermind my question. To falsify my own theory, I see that 
ESP_CONFIG3_TMS == ESP_CONFIG3_FCLK, and thus esp_scsi does actually set 
the relevant bit, and therefore "the FSC can receive 3-byte messages 
during businitiated select with ATN."

-- 

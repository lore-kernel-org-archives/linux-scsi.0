From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Fri, 15 Nov 2002 19:53:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47810000.1037389984@localhost>
References: <004601c28c1f$66cde6c0$13e2cf82@darkwolf>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <004601c28c1f$66cde6c0$13e2cf82@darkwolf>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: didier@ece.gatech.edu, linux-scsi@vger.kernel.org

> I have just connected a brand new UltraTrak SX8000
> (from Promise with 8 x 200GB IDE drives) to an
> adaptec 29160. The UltraTrak SX8000 is connected
> via a brand new LVD cable (1meter).
>
> While everything seems fine, I am getting a bunch of
>
> (scsi0:A:0:0): parity error detected in Data-out phase. SEQADDR(0x56)
> SCSIRATE(0xc2)
>         No terminal CRC packet recevied

I've never seen false positives from this diagnostic.  It looks like
your Promise device is not properly implementing DT transfers.  Is
there a firmware update for the device?

--
Justin

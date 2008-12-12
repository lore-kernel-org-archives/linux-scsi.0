From: "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Thu, 11 Dec 2008 20:27:38 -0700
Message-ID: <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com>
References: <20081210213937.GC25548@parisc-linux.org>
	 <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Raz Ben-Yehuda <razb@bitband.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/10/08, Raz Ben-Yehuda <razb@bitband.com> wrote:
> All gave same results for most dd writes commands.
> dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
> other variants such erase block size ( 128K ) , several erase block size
> and so on. Kernel is 2.6.18-8.el5.
> I used all on a supermicro 1025W-UR. Disks have a SAS interface, 80GB.
> Also, I would like to note, I have 8 disks in array, while each one
> perform READS 250 MB/s, together I degrade to 200 MB/s each. As for
> writes I always reach 20 MB/s at best, from a single disk or 20x8 in
> array.

Out of curiosity, is write cache enabled or disabled on these devices?

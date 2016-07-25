From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 5/5] libata-scsi: fix MODE SELECT translation for
 Control mode page
Date: Mon, 25 Jul 2016 14:30:55 -0400
Message-ID: <20160725183055.GD19588@mtj.duckdns.org>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
 <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
 <14bd98eb08ddf86be28f558817bed3cd27c397cd.1469126217.git.tom.ty89@gmail.com>
 <2ed3f3aba21a4b815e9497e6aeba497280f9f333.1469126217.git.tom.ty89@gmail.com>
 <20160721212600.GF23759@htj.duckdns.org>
 <CAGnHSEnSQcxcaJopGnVusC9Q41qHKkdr4QQDmymFSxVEH6zvPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEnSQcxcaJopGnVusC9Q41qHKkdr4QQDmymFSxVEH6zvPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:50:18AM +0800, Tom Yan wrote:
> As I've mentioned in the comment/message, there is no ATA command
> needed to be sent to the device, since it only toggles a bit in
> dev->flags. See that there is no ata_taskfile constructed in
> ata_mselect_control().

But ata_mselect_caching() contructs a tf?

-- 
tejun

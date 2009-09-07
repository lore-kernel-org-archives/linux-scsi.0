From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for September 7 (scsi/qla2x)
Date: Mon, 7 Sep 2009 10:27:47 -0700
Message-ID: <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090907210206.7830ba68.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 7 Sep 2009 21:02:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090904:


when CONFIG_MODULES=n:

drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type

in
	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
	    KOBJ_CHANGE, envp);

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

From: Greg KH <greg@kroah.com>
Subject: Re: Incorrect driver getting loaded for Qlogic FC-HBA
Date: Mon, 25 Jul 2005 17:06:00 -0700
Message-ID: <20050726000600.GB23858@kroah.com>
References: <b115cb5f0507241902653b6f72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-newbie-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b115cb5f0507241902653b6f72@mail.gmail.com>
Sender: linux-newbie-owner@vger.kernel.org
To: Rajat Jain <rajat.noida.india@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-scsi@vger.kernel.org, linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 25, 2005 at 11:02:39AM +0900, Rajat Jain wrote:
> I'm using Kernel 2.6.9 and am having a Qlogic QLE2362 FC-HBA in my
> system. I selected all the Qlogic SCSI drivers while buiding the
> kernel. Now the problem is that every time I reboot, I have to
> MANUALLY modprobe the qla2322.ko module in the kernel and only then my
> HBA works. By default, the kernel loads qla2300.ko, which is not the
> correct driver for the card, and hence the HBA does not work. Here is
> the lspci output:

"by default" the kernel does not load any modules.  That's up to the
hotplug system, or some other package.

thanks,

greg k-h
-
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs

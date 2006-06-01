From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: Controlling PATA access speeds
Date: Fri, 02 Jun 2006 02:01:03 +0400
Message-ID: <447F639F.6030609@ru.mvista.com>
References: <BAY113-F2199B8BEE31723E17D24CCDF900@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY113-F2199B8BEE31723E17D24CCDF900@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

John Treubig wrote:
> Jeff,
> 
> You bring up a good point in the fact that I believe your refering to 
> detecting 80 wire vs. 40 wire.  We've not tried to use this to our 
> advantage, but it could have some merrit.  What does the driver do if it 
> encounters a 40 wire cable and the drive says it's capable of DMA5?

    Obviously, it limits the speped to UDMA2.

MBR, Sergei

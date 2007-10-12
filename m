From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/3] faster workaround
Date: Fri, 12 Oct 2007 17:08:21 -0400
Message-ID: <470FE245.5040702@garzik.org>
References: <200710081709.18253.bs@q-leap.de> <200710111639.38240.bs@q-leap.de> <470E3B8D.4080002@garzik.org> <200710111718.43159.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200710111718.43159.bs@q-leap.de>
Sender: linux-ide-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bernd Schubert wrote:
> a) 2.6.23 + sil-patch I posted, this is on a customer system (though my former 
> group), I wouldn't like to use -mm there.
> 
> b) .config is attached
> 
> c) attached
> 
> d) attached (don't get irritaded by those machine check events, thats "GART 
> TLB errorr", harmless warnings, just not disabled in the bios).

Any chance you could provide dmesg on 2.6.23 without the sil patch?

	Jeff




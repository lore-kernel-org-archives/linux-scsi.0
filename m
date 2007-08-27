From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mptsas: scan the logical volume at first
Date: Mon, 27 Aug 2007 16:50:52 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709409DF@NAMAIL4.ad.lsil.com>
References: <46D3557C.9010500@sun.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932518AbXH0WvV@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <46D3557C.9010500@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai.Lu@Sun.COM
Cc: Andrew Morton <akpm@linux-foundation.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, August 27, 2007 4:52 PM,  Yinghai Lu wrote:
> Yes, I was wondering why kernel.org mainline will have 
> /dev/sdb for first raid. but it seems RHEL 5 kernel have 
> first raid before second raid...( it 
> after all left over raw devices..), maybe they already aplied 
> some patch?
> 
> can you send out patch?
> 

That is not necessary, as we have already implemented the change to sort
volumes in acsending order to Red hat and Suse, and its been accepted.
I will post the change to lsml.

Eric

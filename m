From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 00/15] Roll-up of my libsas, aic94xx and sas_ata patches
Date: Mon, 20 Nov 2006 17:16:52 -0800
Message-ID: <45625384.90601@us.ibm.com>
References: <20061117210737.17052.67041.stgit@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934284AbWKUBTc@vger.kernel.org>
In-Reply-To: <20061117210737.17052.67041.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alexisb@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Darrick J. Wong wrote:
> Hi all,
> 
> This is a roll-up of all of my patches against libsas, aic94xx and
> sas_ata to date.  The only new patches are #4-5 and #12-15; everything
> else has already been seen in some form on this mailing list.
> Hopefully this will make things a bit saner since most of these have
> been floating out over the past 3 weeks. :)
> 
> (Apologies for any stgit mail misconfiguration on my part.)

I've respun the non sas_ata patches from last week against scsi-misc:
http://sweaglesw.net/~djwong/docs/libsas-patches/ .  The *jejb*patch
files are pulled from aic94xx-sas, so I suppose it's not quite a pure
rebasing; however, some of those patches don't really make any sense
without those three included.

--D

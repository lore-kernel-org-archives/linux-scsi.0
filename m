From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade
Date: Thu, 11 Jul 2019 20:41:25 -0400
Message-ID: <yq136jc84p6.fsf@oracle.com>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
        <20190618013146.21961-2-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618013146.21961-2-marcos.souza.org@gmail.com> (Marcos Paulo
        de Souza's message of "Mon, 17 Jun 2019 22:31:45 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Marcos,

> Currently, all USB devices skip VPD pages, even when the device
> supports them (SPC-3 and later), but some of them support VPD, like
> Cruzer Blade.

We'll try it and see what happens. As I mentioned, SanDisk have
traditionally been pretty good wrt. spec compliance.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Fix the search of first memory bar
Date: Thu, 25 Aug 2016 22:30:00 -0400
Message-ID: <yq18tvkb6tz.fsf@sermon.lab.mkp.net>
References: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 21 Aug 2016 10:28:25 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christophe" == Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

Christophe> The 2nd parameter of 'find_first_bit' is the number of bits
Christophe> to search.  In this case, we are passing 'sizeof(unsigned
Christophe> long)' which is likely to be 4.

Kashyap? Sumit?

-- 
Martin K. Petersen	Oracle Linux Engineering

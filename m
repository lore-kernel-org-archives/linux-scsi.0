From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v9] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 20 Jul 2016 15:26:54 -0500
Message-ID: <826BCCF5-C1E3-4419-9EAB-D0A1253BAA29@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467151535-1443-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <1469045731.13881.4.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1469045731.13881.4.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: joe@perches.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Nic,=20

< SNIP >

    > Note the deletion of drivers/scsi/libsrp.c + include/scsi/libsrp.=
h has
    > been dropped from the above commit, as it looks like they where c=
hanges
    > specific to your local tree.
   =20
    > Please have a quick look, and let me know if anything doesn't loo=
k
    > right.

So the deletion is from James suggesting that I revert the deletion of =
libsrp to make
It clear that the code used to exist in the kernel and that im bringing=
 it back for this driver.
Thus yeah you are right to not include it since those files don=E2=80=99=
t exist currently.

-Bryant
   =20
    --
    To unsubscribe from this list: send the line "unsubscribe target-de=
vel" in
    the body of a message to majordomo@vger.kernel.org
    More majordomo info at  http://vger.kernel.org/majordomo-info.html
   =20
   =20

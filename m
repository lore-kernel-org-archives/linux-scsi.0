From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection information code.
Date: Wed, 15 Apr 2015 11:05:33 -0400
Message-ID: <yq1lhht4eki.fsf@sermon.lab.mkp.net>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
	<552D4C7B.9000402@dev.mellanox.co.il>
	<CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
	<552E384F.3030203@dev.mellanox.co.il>
	<CAC5umygGG4BTs0u35eVi6dLhoDuDshGNPsQaWq2kO5YexWDP+Q@mail.gmail.com>
	<552E76D1.7040204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <552E76D1.7040204@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Wed, 15 Apr 2015 17:33:53 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi> I don't think this is sufficient. With this we actually write
Sagi> unprotected data for WRITE_SAME (i.e. write data blocks but not
Sagi> storing the corresponding PI information). When this data will be
Sagi> read back you will see PI errors (you currently don't see those
Sagi> because your backend drive contains escape values I assume).

Sagi> I'd say the correct fix is to calc PI for the block

Indeed!

Sagi> and "write_same" it...

Well, the ref tag needs to be incremented for each block (for Type 1).

-- 
Martin K. Petersen	Oracle Linux Engineering

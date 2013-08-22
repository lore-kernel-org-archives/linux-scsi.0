From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Wed, 21 Aug 2013 21:25:26 -0400
Message-ID: <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377134271.12003.15.camel@joe-AO722> (Joe Perches's message of
	"Wed, 21 Aug 2013 18:17:51 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akinobu.mita@gmail.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joe" == Joe Perches <joe@perches.com> writes:

Joe> I don't get this build warning in the first place and I think the
Joe> scsi_debug file is quite old and probably doesn't need to be
Joe> changed at all.

guard isn't a boolean, it selects the checksum algorithm used.

Also, I believe Akinobu's recent reorganization of this code in question
fixed the warning.

-- 
Martin K. Petersen	Oracle Linux Engineering

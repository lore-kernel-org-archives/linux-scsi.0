From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5 of 7] block: Block/request layer data integrity support
Date: Mon, 09 Jun 2008 11:06:49 -0400
Message-ID: <yq1od6ak5py.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<5be7c534c9542dc4bab1.1212814538@sermon.lab.mkp.net>
	<20080608042754.GA21251@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761533AbYFIPHf@vger.kernel.org>
In-Reply-To: <20080608042754.GA21251@kroah.com> (Greg KH's message of "Sat\, 7 Jun 2008 21\:27\:54 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Greg" == Greg KH <greg@kroah.com> writes:

>> + /sys/class/block/<bdev>/integrity/write_generate
>> + /sys/class/block/<bdev>/integrity/read_verify

Greg> All of the sysfs interfaces should be documented in
Greg> Documentation/ABI/ not here, otherwise they will be tough to
Greg> find and figure out how to use :)

Will do.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: miyoshi@hpc.bs1.fc.nec.co.jp
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Fri, 21 Jun 2002 11:27:23 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020621112723U.miyoshi@hpc.bs1.fc.nec.co.jp>
References: <20020620162129.F9181@redhat.com>
	<Pine.BSF.4.21.0206201334360.31972-100000@beppo>
	<Pine.BSF.4.21.0206201145290.31972-100000@beppo>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.BSF.4.21.0206201334360.31972-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com, dledford@redhat.com, ctierney@hpti.com, linux-scsi@vger.kernel.org


Hi,

> Hah. The qlogic documentation is clear- you can't span 4GB segments when you
> use 64 bit SCSI requests.

Thanks, it's clear to me now :-)

Perhaps qla2x00's higher 32bits just holds the bits.
It sounds natural from cost consideration :-<

Regards,

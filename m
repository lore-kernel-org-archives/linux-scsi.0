From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 09:53:06 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751608AbWCBQxK@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

In the 'scsi_cmnd' structure, there are two entries holding address
information for data to be transferred. One is 'request_buffer' and the
other one is 'buffer'.
In case of 'use_sg' is non-zero, those entries indicates the address of
the scatter-gather table.

Is there way to get virtual address (so that the data could be accessed
by the driver) of the actual data in the case of 'use_sg' is non-zero?

Any comments would be appreciated.


Thank you,

Seokmann

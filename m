From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: Re: problems with scsi_transport_fc and qla2xxx
Date: Tue, 07 Mar 2006 00:09:53 +0300
Message-ID: <1229893529.20060307000953@netvision.net.il>
References: <1413265398.20060227150526@netvision.net.il>
 <978150825.20060227210552@netvision.net.il>
 <20060228221422.282332ef.akpm@osdl.org> <4406034B.9030105@madness.at>
 <20060301210802.GA7288@spe2> <957728045.20060302193248@netvision.net.il>
 <170fa0d20603061200y38315a62uf143258c79659381@mail.gmail.com>
 <1119462161.20060306230951@netvision.net.il>
 <20060306212835.GO6278@andrew-vasquezs-powerbook-g4-15.local>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932392AbWCFWJ3@vger.kernel.org>
In-reply-to: <20060306212835.GO6278@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Andrew!
After applying the patch the same lock exists:
#001:             [ffff81006edc4080] {scsi_host_alloc}
.. held by:         scsi_wq_4: 4255 [ffff81007edaf770, 110]
... acquired at:               scsi_scan_target+0x51/0x87 [scsi_mod]

Thanks,

Maxim.

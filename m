From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.1
Date: Mon, 20 Dec 2004 17:01:23 +0100
Message-ID: <1103558483.11345.17.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
	 <1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	 <1101394541.5820.71.camel@zezette>  <1102261392.29843.2.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1102261392.29843.2.camel@zezette>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.4.1

Another round of bugfixes.
People are starting to report sane behaviour.

If someone at IBM (or knowledgeable enough) is listening, we need a
method to check a path status on a T200 that don't trigger a controler
bounce. Is it possible at all ?

Full ChangeLog for the release :

        * [multipath] bump SERIAL_SIZE to 19
        * [multipath] add a new group_by_node_name pgpolicy
        * [multipath] move getopt policy parser to
          get_policy_id()
        * [multipath] remove get_evpd_wwid()
        * [checkers] fix the wwn_set test in emc checker
          (Hergen Lange)
        * [checkers] treat the emc checker in the name to
          index translator function (Hergen Lange)
        * [multipath] print to stderr DM unmet requirement
          (Guido Guenther)
        * [multipath] fix realloc return value store not
          propagated to caller by merge_word() (Nicola Ranaldo)

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>



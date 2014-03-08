From: markus <markus@kola.li>
Subject: Re: Slow I/O performance on SAS1064
Date: Sat, 8 Mar 2014 21:14:50 +0100
Message-ID: <20140308201450.GA18581@localhost.localdomain>
References: <CAN7X1Umb_wyTCk9w590AnSTFgL=3CC5x8zGNiGZoAdNEej9TCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAN7X1Umb_wyTCk9w590AnSTFgL=3CC5x8zGNiGZoAdNEej9TCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Purush Gupta <purush.gupta@nutanix.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 08:24:48AM -0800, Purush Gupta wrote:
> I noticed you had benchmarked only sda target, is the behavior same on
> other targets?
>=20
Yes the other disk are equal to sda , but they are used with zfs and there =
were other preformance problems because of the multible disk access.
config:

        NAME        STATE     READ WRITE CKSUM
        home        ONLINE       0     0     0
          raidz1-0  ONLINE       0     0     0
            sdb     ONLINE       0     0     3
            sdc     ONLINE       0     0     0
            sdd     ONLINE       0     0     0



> Since they are SCSI targets, have you explored sg_utils [
> http://sg.danny.cz/sg/uu_index.html]
>=20
> And for benchmarking I also recommend FIO https://github.com/axboe/fio
>=20
Thanks for the tips.
> Good luck,
> Purush
>=20

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTG3o5AAoJENNjYPi2hQIw2SEQAIaoXDMfl3+tJsG1mCzCdp9t
84bBZ3IBYyvR3efF54VJs/RxX3bWnerLiljSz7WXz5Y9O/BmzeuDVN55LTMEMbPo
DmI6Z177SHZgkRw3xYJDwSHX/t8eyfC1sdBH2NgnpNOL4Uw+wEVHdY5ZKRW8nJ7u
C9uAHfLPNnwCfv9PkBeZlRyWk/KHGY6UQC8iJu7ORB1pkNs+MZmq1KCxXLyJGFIh
M197//ax+pcqoRXrsQSbIa4tN633in4LKcE+6UKjQZkXq27AQR6b5bn/Tf0mFOIE
d2SHN8SL/AHIshoq3etzjVbNtpj35SRVjwjqlFl6/ZT0bhDMrGQW7tRg9alLLUG0
bl68BEfEQP1aU2OcXkyW/X5x8yCnt//rBUtN7XTp3UkE5UAtc9u8YY9ZCuHNqWHL
dt+C+OghSG/0mHwdeEltZr4JF4jwJuhB6zbnWS/ZB/Y10IzbdH6i5AOJd4yLJ6e9
TxmVUQDga+K9gr5xMTn5F2uxdYyZsALW4Ss+eOe+e5RGHNhMWNbyw2CuGIw/964v
ksJKg6Dh10ZeIM/C05TPelr8g6l9Pw/k/9q1czMRf0VElnJmQi6NmtRqFNE6l6Uh
xJQ90kYAM3DNSn9f8xJQPMaoeaVeC4KlRXYO9aeYUzr5frierEEk0eEoS4pYvI4N
PYtqW7LUGgGVXFZq17gh
=/jiA
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
